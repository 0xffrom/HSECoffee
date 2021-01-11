package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.entity.ConfirmationCode
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

/**
 * Интерфейс для описания операций для взаимодействия с таблицей хранения кодов для подтверждения.
 * @see ConfirmationCode
 */
@EnableJpaRepositories
@Repository("confirmationCode")
interface ConfirmationCodeRepository : CrudRepository<ConfirmationCode, Long> {
    fun removeConfirmationTokenByEmail(email : String)

    fun existsByEmail(email : String) : Boolean

    fun findByEmail(email : String) : ConfirmationCode?
}