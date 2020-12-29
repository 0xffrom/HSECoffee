package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.*
import com.goga133.hsecoffee.repository.MeetRepository
import com.goga133.hsecoffee.repository.SearchRepository
import com.goga133.hsecoffee.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service

@Service
class MeetService {
    @Qualifier("meetRepository")
    @Autowired
    private val meetRepository: MeetRepository? = null

    @Qualifier("searchRepository")
    @Autowired
    private val searchRepository: SearchRepository? = null

    // Пользователь может искать, может быть уже в встрече, либо ничего.
    // Если он ищет - значит в серчрепе что-то найдётся.
    // Если он не ищет, значит либо встречается, либо ничего.
    // Тогда проверим на статус последней встречи, если встречи нет или статус финешед - значит он свободен
    // иначе - он встречается.
    fun getMeet(user: User): Meet {
        val meet = meetRepository?.findTopByUser1OrUser2(user)

        if (searchRepository?.findSearchByFinder(user) != null) {
            return Meet(user, MeetStatus.SEARCH)
        } else if (meet != null) {
            return meet
        }
        return Meet()
    }

    fun findMeet(user : User, searchParams: SearchParams) : MeetStatus{
        if (searchRepository?.findSearchByFinder(user) != null){
            searchRepository.save(Search(user, searchParams))

        }

    }
}