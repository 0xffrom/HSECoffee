package com.goga133.hsecoffee.entity

import java.time.Duration
import java.time.Instant
import java.util.*
import javax.persistence.*

@Entity
data class RefreshToken(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long,

    @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER)
    @JoinColumn(nullable = false, name = "user_id")
    val user: User,
    @Column(name = "uuid")
    val uuid: UUID = UUID.randomUUID(),
    @Column(name = "fingerprint")
    val fingerprint: String,
    @Temporal(TemporalType.TIMESTAMP)
    val expiresDate: Date = Date.from(Instant.now().plus(Duration.ofDays(60))),

    @Temporal(TemporalType.TIMESTAMP)
    val createdDate: Date = Date.from(Instant.now())
) {
    constructor(user: User, fingerprint: String) : this(
        id = 0,
        user = user,
        fingerprint = fingerprint
    )

    constructor(email: String?) : this(user = User(email), fingerprint = "")

    constructor() : this(User(null), "") {

    }
}