package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.objects.ConfirmationToken
import com.goga133.hsecoffee.objects.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@EnableJpaRepositories
@Repository("confirmationCode")
interface ConfirmationCodeRepository : CrudRepository<ConfirmationToken, Long> {
    fun removeConfirmationTokenByUser(user : User)

    fun existsByUser(user : User) : Boolean

    fun findByUser(user: User) : ConfirmationToken
}