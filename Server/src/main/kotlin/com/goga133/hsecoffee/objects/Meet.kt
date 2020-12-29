package com.goga133.hsecoffee.objects

import java.time.Duration
import java.time.Instant
import java.util.*
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
        var meetStatus: MeetStatus = MeetStatus.NONE,

        @Column(name = "created_date")
        @Temporal(TemporalType.TIMESTAMP)
        val createdDate: Date = Date(),

        @Temporal(TemporalType.TIMESTAMP)
        val expiresDate: Date = Date.from(Instant.now().plus(Duration.ofDays(3)))
        ) {
    constructor() : this(user1 = null, user2 = null, meetStatus = MeetStatus.NONE)
    constructor(user1: User?, meetStatus: MeetStatus) : this(user1 = user1, user2 = null, meetStatus = meetStatus)
    constructor(user1: User, user2: User, meetStatus: MeetStatus) : this(id = 0, user1 = user1, user2 = user2, meetStatus = meetStatus)
}