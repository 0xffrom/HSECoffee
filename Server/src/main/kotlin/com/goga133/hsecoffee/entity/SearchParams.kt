package com.goga133.hsecoffee.entity

import com.goga133.hsecoffee.data.Faculty
import com.goga133.hsecoffee.data.FacultyParams
import org.hibernate.annotations.CollectionType
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


    @Column(name = "faculties")
    @CollectionTable(name="faculties")
    @ElementCollection(targetClass = Faculty::class, fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    val faculties: MutableSet<Faculty> = mutableSetOf(),
) {
    constructor() : this(faculties = mutableSetOf())

    fun getFacultyParams(): FacultyParams
        {
            return when (faculties.size) {
                0 -> FacultyParams.ANY
                1 -> FacultyParams.ONE
                else -> FacultyParams.MANY
            }
        }
}

