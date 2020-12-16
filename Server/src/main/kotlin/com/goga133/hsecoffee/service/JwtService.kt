package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.User
import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jws
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.time.Duration
import java.time.Instant
import java.util.*

@Service
class JwtService(
    @Value("spring.security.oauth2.resourceserver.jwt.EncodedSecretKey256") val secretKey256: String
) {
    fun createAccessToken(user: User): String {
        return Jwts.builder()
            .signWith(Keys.hmacShaKeyFor(secretKey256.toByteArray()), SignatureAlgorithm.HS256)
            .setSubject(user.email)
            .setIssuer("HSE Coffee")
            .setExpiration(Date.from(Instant.now().plus(Duration.ofMinutes(60))))
            .setIssuedAt(Date.from(Instant.now()))
            .compact()

        // TODO: Вынести время в константы
    }

    fun validateAccessToken(token: String): Jws<Claims> {
        return Jwts.parserBuilder()
            .setSigningKey(Keys.hmacShaKeyFor(secretKey256.toByteArray()))
            .build()
            .parseClaimsJws(token)
    }
}