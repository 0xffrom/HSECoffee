package com.goga133.hsecoffee.service

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.data.wrappers.JwtResponseWrapper
import com.goga133.hsecoffee.entity.User
import io.jsonwebtoken.*
import io.jsonwebtoken.security.Keys
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import java.time.Duration
import java.time.Instant
import java.util.*

/**
 * Сервис для работы с Javascript Web Token.
 */
@Service
class JwtService(
    @Value("\${jwt.key}") val secretKey: String,
    @Value("\${jwt.access.min}") val minutes: Long
) {
    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(JwtService::class.java)

    /**
     * Сервис работы с Refresh токенами.
     */
    @Autowired
    val refreshTokenService: RefreshTokenService? = null

    companion object {
        /**
         * Подпись для токена.
         */
        private const val ISSUER = "HSE Coffee"
    }

    /**
     * Метод для создания JWT токена.
     * Алгоритм: [SignatureAlgorithm.HS512]
     * Время действия: [minutes]
     *
     * @param user - Пользователь, относительно которого генерируется токен.
     * @return Токен в [String] представлении.
     */
    fun createAccessToken(user: User): String {
        return Jwts.builder()
            .signWith(Keys.hmacShaKeyFor(secretKey.toByteArray()), SignatureAlgorithm.HS512)
            .setSubject(user.email)
            .setIssuer(ISSUER)
            .setExpiration(Date.from(Instant.now().plus(Duration.ofMinutes(minutes))))
            .setIssuedAt(Date.from(Instant.now()))
            .compact()
    }

    /**
     * Метод для валидации токена средствами [Jwts.parserBuilder]
     * @param token - JWT токен.
     */
    fun validateToken(token: String): JwtResponseWrapper {
        try {
            val claim = parseAccessToken(token)

            if (claim.body?.subject == null)
                return getIncorrectTokenResponse()
        } catch (e: ExpiredJwtException) {
            logger.debug("Срок действие токена $token истекло.")
            return JwtResponseWrapper(HttpStatus.FORBIDDEN, "The token has expired", null)
        } catch (e: JwtException) {
            return getIncorrectTokenResponse()
        }

        logger.debug("Токен $token успешно прошёл валидацию.")
        return JwtResponseWrapper(
            HttpStatus.OK,
            "Correct token",
            parseAccessToken(token).body?.subject ?: return getIncorrectTokenResponse()
        )
    }

    private fun getIncorrectTokenResponse(): JwtResponseWrapper {
        return JwtResponseWrapper(HttpStatus.UNAUTHORIZED, "Incorrect token", null)
    }

    /**
     * Преобразование токена из [String] в [Jws] спомощью [Jwts.parserBuilder]
     * @see Jwts.parserBuilder
     * @see Jws
     */
    fun parseAccessToken(token: String): Jws<Claims> {
        return Jwts.parserBuilder()
            .setSigningKey(Keys.hmacShaKeyFor(secretKey.toByteArray()))
            .build()
            .parseClaimsJws(token)
    }

    /**
     * Получение на основе пользователя и отпечатка пару из Access и Refresh токенов в JSON формате.
     * @param user - Пользователь, для которого генерируются токены.
     * @param fingerPrint - Отпечаток для валидации устройства пользователя.
     * @return JSON с полями accessToken и refreshToken
     */
    fun getJsonTokens(user: User, fingerPrint: String): String {
        val accessToken = createAccessToken(user)
        val refreshToken = refreshTokenService?.createByUser(user, fingerPrint)?.uuid

        logger.debug("Для $user получены access и refresh токены.")

        return jacksonObjectMapper().writeValueAsString(
            mapOf<String, Any?>(
                "accessToken" to accessToken,
                "refreshToken" to refreshToken
            )
        )
    }
}