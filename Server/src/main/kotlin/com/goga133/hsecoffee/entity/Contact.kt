package com.goga133.hsecoffee.entity

import javax.persistence.*

@Entity
data class Contact(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "contact_id")
    val id: Long = 0,

    @ManyToOne(targetEntity = User::class, fetch = FetchType.EAGER, cascade = [CascadeType.ALL])
    @JoinColumn(name = "user_id")
    var user: User? = null,
    @Column(name = "name")
    val name: String,
    @Column(name = "value")
    val value: String
) {
    constructor() : this(name = "", value = "") {

    }
}