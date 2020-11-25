package com.goga133.hsecoffee.objects

import javax.persistence.*

@Entity
data class User(
        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
        @Column(name = "user_id")
        val userid: Long = 0,
        val email: String? = null,
        @Column(name = "first_name")
        val firstName: String? = null,
        @Column(name = "last_name")
        val lastName: String? = null,
        @Column(name = "is_enabled")
        var isEnabled: Boolean = false)