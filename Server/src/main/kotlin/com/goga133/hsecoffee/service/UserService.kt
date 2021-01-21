package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.repository.UserRepository
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.net.InetAddress

/**
 * Сервис для работы с пользователями.
 */
@Service
class UserService(
    @Value("\${storage.folder}")
    private val folder: String
) {
    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(UserService::class.java)

    /**
     * Репозиторий для работы с пользователями.
     */
    @Qualifier("userRepository")
    @Autowired
    private val userRepository: UserRepository? = null

    /**
     * Метод для получения пользователя по email. Если такого пользователя нет в базе данных,
     * то он создаётся и сохраняется в ней.
     *
     * @param email - email адрес пользователя.
     * @return пользователь с данным email.
     */
    fun getUserByEmailOrCreate(email: String): User? {
        var user = getUserByEmail(email)

        if (user == null) {
            user = createUserByEmail(email)
            logger.debug("Пользователь $user успешно создан.")
        }

        return user
    }

    /**
     * Метод для поиска пользователей с помощью email адреса.
     * Если такого пользователя не нашлось, возвращается null.
     *
     * @param email - email адрес.
     * @return [User], [User.email] которого равен [email], или null, если пользователя не нашлось.
     */
    fun getUserByEmail(email: String): User? {
        val user = userRepository?.findByEmail(email = email)

        if (user == null)
            logger.debug("Неизвестный $user для email = $email")
        return user
    }

    /**
     * Создание в БД пользователя с email = [email].
     *
     * @param email - email, для которого нужно создать пользователя.
     */
    fun createUserByEmail(email: String): User {
        val user = User(email)

        userRepository?.save(user)
        return user
    }

    /**
     * Метод для смена у пользователя пути с его фотографией.
     * Фотография пользователя всегда находится по пути uploads/{email}.png.
     * @param user - пользователь, для которого нужно поменять путь его фотографии.
     */
    fun changeFolderAndSave(user: User) {
        with(user) {
            photoUri = "${folder}${user.email}.png"
            save(this)

            logger.debug("Пользователю $user был присвоен путь для фотографии.")
        }

    }

    /**
     * Сохранение или обновление записи о пользователе в БД.
     * @param user - пользователь, чью учётную запись необходимо обновить/сохранить в БД.
     */
    fun save(user: User) {
        userRepository?.save(user)
    }
}