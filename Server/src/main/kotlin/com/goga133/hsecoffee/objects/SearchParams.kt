package com.goga133.hsecoffee.objects

import javax.persistence.*

@Entity
data class SearchParams(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long = 0,

    @Column(name = "faculties")
    @ElementCollection
    val faculties: Set<Faculty>? = null,
) {
    constructor() : this(faculties = null)

    val facultyParams: FacultyParams
        get() {
            if (faculties == null)
                return FacultyParams.NONE

            return when (faculties.size) {
                0 -> FacultyParams.ANY
                1 -> FacultyParams.ONE
                else -> FacultyParams.MANY
            }
        }
}

