package com.goga133.hsecoffee.entity

import com.goga133.hsecoffee.data.Faculty
import com.goga133.hsecoffee.data.FacultyParams
import javax.persistence.*

@Entity
data class SearchParams(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long = 0,

    @Column(name = "faculties")
    @ElementCollection
    val faculties: Set<Faculty> = setOf(),
) {
    constructor() : this(faculties = setOf())

    fun getFacultyParams(): FacultyParams
        {
            return when (faculties.size) {
                0 -> FacultyParams.ANY
                1 -> FacultyParams.ONE
                else -> FacultyParams.MANY
            }
        }
}

