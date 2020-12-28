package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.objects.ConfirmationCode
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@EnableJpaRepositories
@Repository("confirmationCode")
interface ConfirmationCodeRepository : CrudRepository<ConfirmationCode, Long> {
    fun removeConfirmationTokenByEmail(email : String)

    fun existsByEmail(email : String) : Boolean

    fun findByEmail(email : String) : ConfirmationCode?

    fun findByCode(code : Int) : ConfirmationCode?
}