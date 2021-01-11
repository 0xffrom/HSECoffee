package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.entity.RefreshToken
import com.goga133.hsecoffee.entity.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

/**
 * Интерфейс для описания операций для взаимодействия с таблицей для хранения Refresh токенов.
 * @see RefreshToken
 */
@EnableJpaRepositories
@Repository("refreshTokenRepository")
interface RefreshTokenRepository: CrudRepository<RefreshToken, Long> {
    fun findRefreshTokenByUser(user : User) : RefreshToken?
}