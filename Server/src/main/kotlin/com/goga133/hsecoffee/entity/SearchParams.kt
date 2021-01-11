package com.goga133.hsecoffee.entity

import com.goga133.hsecoffee.data.Faculty
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
}

