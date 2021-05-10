package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.entity.Meet
import com.goga133.hsecoffee.entity.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

/**
 * Интерфейс для описания операций для взаимодействия с таблицей встреч.
 * @see Meet
 */
@EnableJpaRepositories
@Repository("meetRepository")
interface MeetRepository : CrudRepository<Meet, Long> {
    fun findAllByUser1OrUser2(user1: User, user2: User): List<Meet>?

    fun existsMeetById(id: Long): Boolean
}