package com.goga133.hsecoffee.objects

import javax.persistence.*

@Entity
data class Meet(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long,

    @Column(name = "user1")
    @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER, cascade = [CascadeType.ALL])
    @JoinColumn(nullable = false, name = "user_id")
    val user1: User?,

    @Column(name = "user2")
    @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER, cascade = [CascadeType.ALL])
    @JoinColumn(nullable = false, name = "user_id")
    val user2: User?,

    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    val status: Status = Status.NONE
) {
    constructor() : this(0, user1 = null, user2 = null, status = Status.NONE) {

    }
}