package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.User
import io.jsonwebtoken.*
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.PropertySource
import org.springframework.stereotype.Service
import java.time.Duration
import java.time.Instant
import java.util.*

@Service
@PropertySource("jwt.properties")
class JwtService(
        @Value("\${jwt.key}") val secretKey: String,
        @Value("\${jwt.access.min}") val minutes: Long
) {
    fun createAccessToken(user: User): String {
        return Jwts.builder()
                .signWith(Keys.hmacShaKeyFor(secretKey.toByteArray()), SignatureAlgorithm.HS512)
                .setSubject(user.email)
                .setIssuer("HSE Coffee")
                .setExpiration(Date.from(Instant.now().plus(Duration.ofMinutes(minutes))))
                .setIssuedAt(Date.from(Instant.now()))
                .compact()
    }

    /**
     * Валидация access - токена библиотечным способом
     * @see Jwts.parserBuilder
     */
    @Throws(MalformedJwtException::class, io.jsonwebtoken.security.SecurityException::class,
            ExpiredJwtException::class, IllegalArgumentException::class)
    fun validateAccessToken(token: String): Jws<Claims> {
        return Jwts.parserBuilder()
                .setSigningKey(Keys.hmacShaKeyFor(secretKey.toByteArray()))
                .build()
                .parseClaimsJws(token)
    }
}