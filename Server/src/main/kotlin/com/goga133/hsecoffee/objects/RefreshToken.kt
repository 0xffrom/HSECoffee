package com.goga133.hsecoffee.objects

import java.time.Duration
import java.time.Instant
import java.util.*
import javax.persistence.*

@Entity
data class RefreshToken(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    val id: Long,

    @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER)
    @JoinColumn(nullable = false, name = "user_id")
    val user: User,
    @Column(name = "uuid")
    val uuid: UUID = UUID.randomUUID(),
    @Column(name = "finger_print")
    val fingerPrint: String,
    @Temporal(TemporalType.TIMESTAMP)
    val expiresDate: Date = Date.from(Instant.now().plus(Duration.ofDays(60))),

    @Temporal(TemporalType.TIMESTAMP)
    val createdDate: Date = Date.from(Instant.now())
) {
    constructor(user: User, fingerPrint: String) : this(
        id = 0,
        user = user,
        fingerPrint = fingerPrint
    )

    constructor() : this(user = User(), fingerPrint = "")
}