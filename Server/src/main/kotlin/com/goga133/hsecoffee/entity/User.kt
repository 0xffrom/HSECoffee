package com.goga133.hsecoffee.entity

import com.goga133.hsecoffee.data.Degree
import com.goga133.hsecoffee.data.Faculty
import com.goga133.hsecoffee.data.Gender
import com.goga133.hsecoffee.data.status.UserStatus
import java.util.*
import javax.persistence.*
import kotlin.collections.HashSet

/**
 * Data-class. Пользователь.
 */
@Entity
data class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    val id: Long = 0,

    @Column(name = "email", nullable = false, unique = true)
    val email: String = "",

    @Column(name = "first_name")
    var firstName: String = "",

    @Column(name = "last_name")
    var lastName: String = "",

    @Column(name = "sex")
    @Enumerated(EnumType.STRING)
    var gender: Gender = Gender.NONE,

    @Column(name = "created_date")
    @Temporal(TemporalType.TIMESTAMP)
    val createdDate: Date = Date(),

    @Enumerated(EnumType.STRING)
    @Column(name = "faculty")
    var faculty: Faculty = Faculty.NONE,

    @Enumerated(EnumType.STRING)
    @Column(name = "degree")
    var degree: Degree = Degree.NONE,

    @Column(name = "contacts")
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    var contacts: Set<Contact> = HashSet<Contact>(),

    @Column(name = "course")
    var course: Int = 0,

    @Column(name = "user_status")
    @Enumerated(EnumType.STRING)
    var userStatus: UserStatus = UserStatus.UNKNOWN,

    @Column(name = "photo_uri")
    var photoUri: String = "uploads/default/${gender.name}.png"
) {

    constructor(email: String?) : this(
        email = email.toString(),
        userStatus = UserStatus.ACTIVE
    )

    constructor() : this(null)

}