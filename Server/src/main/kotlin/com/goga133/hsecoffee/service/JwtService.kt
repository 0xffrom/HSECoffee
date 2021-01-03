package com.goga133.hsecoffee.service

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.data.TokenResponse
import com.goga133.hsecoffee.entity.User
import io.jsonwebtoken.*
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.PropertySource
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import java.time.Duration
import java.time.Instant
import java.util.*

@Service
@PropertySource("classpath:jwt.properties")
class JwtService(
    @Value("\${jwt.key}") val secretKey: String,
    @Value("\${jwt.access.min}") val minutes: Long
) {

    @Autowired
    val refreshTokenService : RefreshTokenService? = null

    fun createAccessToken(user: User): String {
        return Jwts.builder()
            .signWith(Keys.hmacShaKeyFor(secretKey.toByteArray()), SignatureAlgorithm.HS512)
            .setSubject(user.email)
            .setIssuer("HSE Coffee")
            .setExpiration(Date.from(Instant.now().plus(Duration.ofMinutes(minutes))))
            .setIssuedAt(Date.from(Instant.now()))
            .compact()
    }

    fun validateToken(token: String): TokenResponse {
        try {
            val claim = parseAccessToken(token)

            if (claim.body?.subject == null)
                return getIncorrectTokenResponse()
        } catch (e: ExpiredJwtException) {
            return TokenResponse(HttpStatus.FORBIDDEN, "The token has expired", null)
        } catch (e: JwtException) {
            return getIncorrectTokenResponse()
        }

        return  TokenResponse(
            HttpStatus.OK,
            "Correct token",
            parseAccessToken(token).body?.subject ?: return getIncorrectTokenResponse())
    }

    private fun getIncorrectTokenResponse(): TokenResponse {
        return TokenResponse(HttpStatus.UNAUTHORIZED, "Incorrect token", null)
    }

    /**
     * Валидация access - токена библиотечным способом
     * @see Jwts.parserBuilder
     */
    fun parseAccessToken(token: String): Jws<Claims> {
        return Jwts.parserBuilder()
            .setSigningKey(Keys.hmacShaKeyFor(secretKey.toByteArray()))
            .build()
            .parseClaimsJws(token)
    }


    fun getJsonTokens(user: User, fingerPrint: String): String {
        val accessToken = createAccessToken(user)
        val refreshToken = refreshTokenService?.createByUser(user, fingerPrint)?.uuid

        return jacksonObjectMapper().writeValueAsString(
            mapOf<String, Any?>(
                "accessToken" to accessToken,
                "refreshToken" to refreshToken
            )
        )
    }
}