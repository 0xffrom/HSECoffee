package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.objects.ConfirmationToken
import com.goga133.hsecoffee.objects.User
import org.springframework.data.repository.CrudRepository


interface ConfirmationCodeRepository : CrudRepository<ConfirmationToken, Int> {
    fun findByUserEmail(email: String): ConfirmationToken

    fun existsByUserEmail(email: String) : Boolean

    fun removeConfirmationTokenByUser(user: User)
}