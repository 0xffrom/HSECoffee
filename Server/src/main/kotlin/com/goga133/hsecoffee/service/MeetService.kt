package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.objects.*
import com.goga133.hsecoffee.repository.MeetRepository
import com.goga133.hsecoffee.repository.SearchRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import java.util.*

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
        // Мы ищим среди всех встреч
        val meet = meetRepository?.findTopByUser1OrUser2(user)

        if (searchRepository?.findSearchByFinder(user) != null) {
            return Meet(user, MeetStatus.SEARCH)
        } else if (meet != null) {
            return meet.apply {
                updateMeetStatus(this)
            }
        }
        return Meet()
    }

    fun deleteMeet(user: User) {

    }

    fun searchMeet(user: User, searchParams: SearchParams): MeetStatus {
        if (meetRepository?.findTopByUser1OrUser2(user)?.apply { updateMeetStatus(this) }?.meetStatus == MeetStatus.ACTIVE)
            return MeetStatus.ACTIVE

        // Если его нет в доске поиска:
        if (searchRepository?.findSearchByFinder(user) == null) {
            val searches = searchRepository?.findAll()

            val finder = searches?.firstOrNull {
                // Если обоим пользователям всё равно, кого искать:
                if (searchParams.facultyParams == FacultyParams.ANY && it.searchParams?.facultyParams == FacultyParams.ANY)
                    return@firstOrNull true
                // Если первому всё равно, смотрим на второго: содержится ли в его предпочтениях факультет первого.
                else if (searchParams.facultyParams == FacultyParams.ANY && (it?.searchParams?.faculties?.contains(user.faculty) == true))
                    return@firstOrNull true
                // Тоже самое, только наоборот.
                else if (it.searchParams?.facultyParams == FacultyParams.ANY && searchParams.faculties?.contains(it.finder?.faculty) == true)
                    return@firstOrNull true
                // Смотрим, содержатся ли в предпочтениях факультет собеседника:
                else if (searchParams.faculties?.contains(it.finder?.faculty!!) == true
                        && it?.searchParams?.faculties?.contains(user.faculty) == true)
                    return@firstOrNull true

                return@firstOrNull false
            }

            // Если поиск неудачен, то добавляем в зал ожидания.
            return if (finder?.finder == null) {
                searchRepository?.save(Search(user, searchParams))

                MeetStatus.SEARCH
            }
            // Если поиск удачен - делаем встречу.
            else {
                searchRepository?.delete(finder)

                meetRepository?.save(Meet(user, finder.finder, MeetStatus.ACTIVE))

                MeetStatus.ACTIVE
            }
        }
        return MeetStatus.SEARCH
    }

    private fun updateMeetStatus(meet : Meet) {
        if (Date() >= meet.expiresDate || meet.meetStatus == MeetStatus.FINISHED) {
            meet.meetStatus = MeetStatus.FINISHED
        }

        meetRepository?.save(meet);
    }
}