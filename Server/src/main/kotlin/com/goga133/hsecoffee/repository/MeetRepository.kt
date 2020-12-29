package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.objects.Meet
import com.goga133.hsecoffee.objects.Search
import com.goga133.hsecoffee.objects.User
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@EnableJpaRepositories
@Repository("meetRepository")
interface MeetRepository : CrudRepository<Meet, Long> {
    fun findTopByUser1OrUser2(user: User) : Meet?
}