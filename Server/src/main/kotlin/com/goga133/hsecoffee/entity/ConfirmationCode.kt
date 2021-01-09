package com.goga133.hsecoffee.entity

import java.util.*
import javax.persistence.*
import kotlin.random.Random

/**
 * Data-class. Email-код для подтверждения аккаунта.
 */
@Entity
data class ConfirmationCode(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    val id: Long = 0,

    @Column(name = "code")
    val code: Int = Random.nextInt(MIN_CODE, MAX_CODE),

    @Column(name = "created_date")
    @Temporal(TemporalType.TIMESTAMP)
    val createdDate: Date = Date(),

    @Column(name = "email")
    val email: String? = null
) {

    companion object {
        private const val MIN_CODE = 100000
        private const val MAX_CODE = 1000000
    }

    constructor(email: String) : this(
        email = email,
        createdDate = Date(),
        code = Random.nextInt(MIN_CODE, MAX_CODE)
    ) {
        //
    }


    constructor(email: String, code: Int) : this(
        email = email,
        createdDate = Date(),
        code = code
    ) {
        //
    }
}
