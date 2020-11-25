package com.goga133.hsecoffee.objects

import java.util.*
import javax.persistence.*
import kotlin.random.Random


@Entity
data class ConfirmationToken(
        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
        @Column(name = "code_id")
        val codeId: Long = 0,

        @Column(name = "code")
        val code: Int = Random.nextInt(100000, 1000000),

        @Temporal(TemporalType.TIMESTAMP)
        val createdDate: Date = Date(),

        @OneToOne(targetEntity = User::class, fetch = FetchType.EAGER)
        @JoinColumn(nullable = false, name = "user_id")
        val user: User? = null) {

    constructor(user: User) : this(
            user = user,
            createdDate = Date(),
            code = Random.nextInt(100000, 1000000)) {
        //
    }

}