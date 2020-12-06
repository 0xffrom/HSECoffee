package com.goga133.hsecoffee.objects

import java.util.*
import javax.persistence.*

@Entity
data class User(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "user_id")
        val userid: Long = 0,
        val email: String? = null,
        @Column(name = "first_name")
        val firstName: String? = null,
        @Column(name = "last_name")
        val lastName: String? = null,
        @Enumerated(EnumType.STRING)
        val sex : Sex? = null,
        @Temporal(TemporalType.TIMESTAMP)
        val createdDate: Date = Date(),
        @Column(name = "is_enabled")
        var isEnabled: Boolean = false) {

     constructor(email: String?, isEnabled: Boolean) : this(email = email) {
        this.isEnabled = isEnabled
    }
}