FROM node:20.11.1-alpine3.19 as build
RUN apk update && apk upgrade
WORKDIR /app
COPY package* ./
RUN  npm install
COPY . ./
RUN npx nuxt build
FROM node:20.11.1-alpine3.19
RUN apk update && apk upgrade && apk add dumb-init && adduser -D nuxtuser
USER nuxtuser
WORKDIR /app
COPY --chown=nuxtuser:nuxtuser --from=build /app/.output ./
LABEL authors="erikson.melgarejo"
LABEL org.opencontainers.image.source="https://github.com/sonils/planils-dashboard"
LABEL org.opencontainers.image.description="Planils Dashboard"
LABEL org.opencontainers.image.author="Erikson Melgarejo"
LABEL org.opencontainers.image.licenses=MIT
EXPOSE 5301
ENV HOST=0.0.0.0 PORT=5301 NODE_ENV=production NUXT_PUBLIC_API_URL=NO_URL_CONFIGURED
CMD ["dumb-init","node","/app/server/index.mjs"]
