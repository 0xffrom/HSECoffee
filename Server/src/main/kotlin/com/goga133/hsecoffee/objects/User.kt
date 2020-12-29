package com.goga133.hsecoffee.objects

import java.util.*
import javax.persistence.*

@Entity
data class User(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "user_id")
        val userid: Long = 0,

        @Column(name = "email")
        val email: String? = null,

        @Column(name = "first_name")
        var firstName: String? = null,

        @Column(name = "last_name")
        var lastName: String? = null,

        @Column(name = "sex")
        @Enumerated(EnumType.STRING)
        var sex: Sex = Sex.NONE,

        @Column(name = "created_date")
        @Temporal(TemporalType.TIMESTAMP)
        val createdDate: Date = Date(),

        @Enumerated(EnumType.STRING)
        @Column(name = "faculty")
        var faculty: Faculty = Faculty.NONE,

        @Column(name = "contacts")
        @ElementCollection
        var contacts: List<String>,

        @Column(name = "course")
        var course: Int
) {

    constructor(email: String?) : this(
            email = email,
            firstName = null,
            lastName = null,
            contacts = ArrayList(),
            course = 1
    ) {

    }

    constructor() : this(null) {

    }
}