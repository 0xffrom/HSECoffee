package com.goga133.hsecoffee.entity

import com.goga133.hsecoffee.data.Faculty
import com.goga133.hsecoffee.data.Sex
import com.goga133.hsecoffee.data.status.UserStatus
import java.util.*
import javax.persistence.*

@Entity
data class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    val id: Long = 0,

    @Column(name = "email", nullable = false, unique = true)
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
    @ElementCollection(targetClass = String::class, fetch = FetchType.EAGER)
    var contacts: List<String>,

    @Column(name = "course")
    var course: Int,

    @Column(name = "user_status")
    @Enumerated(EnumType.STRING)
    var userStatus: UserStatus = UserStatus.UNKNOWN,

    @Column(name = "photo_uri")
    var photoUri: String? = null
) {

    constructor(email: String?) : this(
        email = email,
        firstName = null,
        lastName = null,
        contacts = ArrayList(),
        course = 1,
        userStatus = UserStatus.ACTIVE
    )

    constructor() : this(null)
}