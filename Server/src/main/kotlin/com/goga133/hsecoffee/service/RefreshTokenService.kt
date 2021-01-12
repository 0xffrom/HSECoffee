package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.RefreshToken
import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.repository.RefreshTokenRepository
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.*

/**
 * Сервис для работы с Refresh токенами.
 */
@Service
class RefreshTokenService {
    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(RefreshTokenService::class.java)

    /**
     * Репозиторий для работы с Refresh токенами.
     */
    @Qualifier("refreshTokenRepository")
    @Autowired
    private val refreshTokenRepository: RefreshTokenRepository? = null

    /**
     * Создание Refresh токена [RefreshToken] на основе пользователя и отпечатка.
     * Отпечаток используется как уникальный идентификатор устройства.
     *
     * @param user - пользователь, относительно которого создаётся токен.
     * @param fingerprint - отпечаток, т.е идентификатор устройства.
     */
    @Transactional
    fun createByUser(user: User, fingerprint: String): RefreshToken {
        // Если существует:
        val refreshToken = RefreshToken(user, fingerprint)

        val refreshTokenRep = refreshTokenRepository?.findRefreshTokenByUser(user)
        if (refreshTokenRep != null) {
            logger.debug("Токен $refreshTokenRep удалён для $user")
            refreshTokenRepository?.delete(refreshTokenRep)
        }

        refreshTokenRepository?.save(refreshToken)

        logger.debug("Для $user был создан $refreshToken")
        return refreshToken
    }

    /**
     * Проверка на корректность Refresh токена [RefreshToken].
     *
     * @return True - если Refresh token верный, иначе - False.
     */
    fun isValid(user: User, token: UUID, fingerprint: String): Boolean {
        val refreshToken = refreshTokenRepository?.findRefreshTokenByUser(user) ?: return false

        if (refreshToken.uuid == token &&
            refreshToken.expiresDate.after(Date()) &&
            refreshToken.fingerprint == fingerprint
        ) {
            logger.debug("Refresh token $token для $user корректный.")
            return true
        }

        logger.debug("Refresh token $token для $user неверный.")
        return false
    }
}