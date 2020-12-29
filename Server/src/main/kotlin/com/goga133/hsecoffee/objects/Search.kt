package com.goga133.hsecoffee.objects

import java.util.*
import javax.persistence.*

@Entity
data class Search(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long = 0,

    @Column(name = "finder")
    @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER, cascade = [CascadeType.ALL])
    @JoinColumn(nullable = false, name = "user_id")
    val finder: User? = null,

    @Column(name = "search_params")
    @OneToOne(targetEntity = SearchParams::class, fetch = FetchType.EAGER, cascade = [CascadeType.ALL])
    @JoinColumn(nullable = false, name = "id")
    val searchParams: SearchParams? = null,

    @Column(name = "created_date")
    @Temporal(TemporalType.TIMESTAMP)
    val createdDate: Date = Date()
){
    constructor(finder: User?, searchParams: SearchParams?) : this(0, finder, searchParams)
}