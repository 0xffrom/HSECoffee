package com.goga133.hsecoffee.objects

import javax.persistence.*

@Entity
data class Meet(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long = 0,

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
    val meetStatus: MeetStatus = MeetStatus.NONE
) {
    constructor() : this(user1 = null, user2 = null, meetStatus = MeetStatus.NONE)
    constructor(user1: User?, meetStatus: MeetStatus) : this(user1 = user1, user2 = null, meetStatus = meetStatus)
}