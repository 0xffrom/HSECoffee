package com.goga133.hsecoffee.service

import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.repository.ImageStorageRepository
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.io.IOException
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths

/**
 * Сервис для загрузки изображений для пользователя.
 * Изображения хранятся в root/uploads, где root - корневая папка.
 * Название изображения - email.png, где email - электронная почта пользователя.
 * Реализует ImageStorageRepository
 * @see ImageStorageRepository
 */
@Service
class ImageStorageService : ImageStorageRepository {
    @Autowired
    private val userService: UserService? = null

    /**
     * Логгер.
     */
    private val logger: Logger = LoggerFactory.getLogger(ImageStorageService::class.java)

    companion object{
        /**
         * Корневая папка для хранения изображений.
         */
        private val rootLocation: Path = Paths.get("uploads")

        /**
         * Метод для создания корневой папки.
         */
        fun init() {
            if (!Files.exists(rootLocation)) {
                Files.createDirectory(rootLocation)
            }
        }
    }

    /**
     * Метод для проверки корректности изображения.
     * Изображение должно быть формата image типа png, jpg или jpeg.
     */
    override fun correctFile(file: MultipartFile): Boolean {
        if (file.isEmpty) {
            return false
        }

        val contentType: String = file.contentType ?: return false

        if (!isSupportedContentType(contentType)) {
            logger.debug("Тип файла не является фотографией.")
            return false
        }

        logger.debug("Изображение корректное")
        return true
    }

    /**
     * Метод для провеки корректности типа файла.
     */
    private fun isSupportedContentType(contentType: String): Boolean {
        return contentType == "image/png"
                || contentType == "image/jpg"
                || contentType == "image/jpeg"
    }

    /**
     * Метод для загрузки фотографии в корневую папку.
     * Если фотография уже существовала, она удалится.
     */
    override fun store(file: MultipartFile, user: User) {
        try {
            // Удаляем если существует:
            Files.deleteIfExists(rootLocation.resolve(user.email.toString() + ".png"))

            // Помещаем в память:
            Files.copy(file.inputStream, rootLocation.resolve(user.email.toString() + ".png"))

            logger.debug("Фотография для пользователя $user была успешно помещена на сервер.")
            // Меняем у пользователя:
            userService?.changeFolderAndSave(user)
        }
        catch (io : IOException){
            logger.error("Произошла ошибка при работе с файлами.", io)
        }
    }
}