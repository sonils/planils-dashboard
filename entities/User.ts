import { Entity, PrimaryGeneratedColumn, Column } from "typeorm"

@Entity()
export class Category {

    id: number

    @Column()
    name: string

    @Column()
    email: string
}