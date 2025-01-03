// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    compatibilityDate: '2024-11-01',
    devtools: {enabled: true},
    app: {
        rootTag : 'body',
        head: {
            titleTemplate : "Sonils Dashboard | %s",
            htmlAttrs: {
                lang: 'pt-PT',
                "data-theme": "light"
            },
            link: [
                { rel: 'icon', type: 'image/png', href: '/favicon.png' }
            ]
        }
    },
    modules: ['@nuxtjs/tailwindcss', 'nuxt-time'],
    runtimeConfig: {
        app: {
            conn: process.env.NUXT_CONN
        }
    }
})