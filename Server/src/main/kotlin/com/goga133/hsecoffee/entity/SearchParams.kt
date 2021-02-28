package com.goga133.hsecoffee.entity

import com.goga133.hsecoffee.data.Degree
import com.goga133.hsecoffee.data.Faculty
import com.goga133.hsecoffee.data.Gender
import javax.persistence.*

/**
 * Data-class. Параметры поиска встреч.
 */
@Entity
data class SearchParams(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long = 0,

    @Column(name = "genders")
    @CollectionTable(name = "genders")
    @ElementCollection(targetClass = Gender::class, fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    val genders: MutableSet<Gender> = mutableSetOf(),

    @Column(name = "min_course")
    val minCourse: Int = 1,
    @Column(name = "max_course")
    val maxCourse: Int = 6,

    @Column(name = "degrees")
    @CollectionTable(name = "degrees")
    @ElementCollection(targetClass = Degree::class, fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    val degrees: MutableSet<Degree> = mutableSetOf(),

    @Column(name = "faculties")
    @CollectionTable(name = "faculties")
    @ElementCollection(targetClass = Faculty::class, fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    val faculties: MutableSet<Faculty> = mutableSetOf()
)
