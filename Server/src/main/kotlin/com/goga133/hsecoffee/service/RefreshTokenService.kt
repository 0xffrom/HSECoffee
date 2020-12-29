package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.RefreshToken
import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.repository.RefreshTokenRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.*

@Service
class RefreshTokenService {
    @Qualifier("refreshTokenRepository")
    @Autowired
    private val refreshTokenRepository: RefreshTokenRepository? = null

    @Transactional
    fun createByUser(user: User, fingerprint: String): RefreshToken {
        // Если существует:
        val refreshToken = RefreshToken(user, fingerprint)

        val refreshTokenRep = refreshTokenRepository?.findRefreshTokenByUser(user);
        if (refreshTokenRep != null) {
            refreshTokenRepository?.delete(refreshTokenRep)
        }

        refreshTokenRepository?.save(refreshToken)

        return refreshToken
    }

    fun isValid(user: User, token: UUID, fingerprint: String): Boolean {
        val refreshToken = refreshTokenRepository?.findRefreshTokenByUser(user) ?: return false

        if (refreshToken.uuid == token &&
            refreshToken.expiresDate.after(Date()) &&
            refreshToken.fingerprint == fingerprint){
            return true
        }

        return false
    }
}