package com.goga133.hsecoffee.entity

import java.util.*
import javax.persistence.*

/**
 * Data-class. Поиск. Требуется для реализации поиска встреч.
 */
@Entity
data class Search(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long = 0,

    @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER)
    @JoinColumn(nullable = false, name = "user_id")
    val finder: User,

    @OneToOne(targetEntity = SearchParams::class, fetch = FetchType.EAGER, cascade = [CascadeType.ALL])
    @JoinColumn(nullable = false, name = "search_params")
    var searchParams: SearchParams,

    @Column(name = "created_date")
    @Temporal(TemporalType.TIMESTAMP)
    val createdDate: Date = Date()
) {
    constructor(finder: User, searchParams: SearchParams) : this(0, finder, searchParams)
    constructor() : this(User(null), SearchParams()) {

    }
}