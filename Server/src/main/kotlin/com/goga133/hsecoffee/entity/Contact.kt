package com.goga133.hsecoffee.entity

import javax.persistence.*

@Entity
data class Contact(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "contact_id")
    val id: Long = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    val user: User? = null,
    @JoinColumn(name = "name")
    val name: String,
    @JoinColumn(name = "value")
    val value: String
) {
    constructor() : this(name = "", value = "") {

    }
}