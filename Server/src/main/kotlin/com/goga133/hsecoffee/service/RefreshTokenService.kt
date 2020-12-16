package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.RefreshToken
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.repository.RefreshTokenRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class RefreshTokenService {
    @Autowired
    private val refreshTokenRepository : RefreshTokenRepository? = null

    fun createByUser(user: User, fingerPrint : String) : RefreshToken{
        // Если существует:
        val refreshToken : RefreshToken = RefreshToken(user, fingerPrint)

        val refreshTokenRep = refreshTokenRepository?.findRefreshTokenByUser(user);
        if(refreshTokenRep != null){
            refreshTokenRepository?.delete(refreshTokenRep)
        }

        refreshTokenRepository?.save(refreshToken)

        return refreshToken
    }
}