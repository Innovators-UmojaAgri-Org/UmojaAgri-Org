const express = require("express");
const router = express.Router();
const auth = require("../../shared/middleware/auth");
const {
  listNotifications,
  markAsRead,
  markAllAsRead,
} = require("./notificationsController");

/**
 * @swagger
 * /api/notifications:
 *   get:
 *     tags: [Notifications]
 *     summary: List notifications for current user
 *     responses:
 *       200:
 *         description: List of notifications
 */
router.get("/", auth, listNotifications);

/**
 * @swagger
 * /api/notifications/{id}/read:
 *   patch:
 *     tags: [Notifications]
 *     summary: Mark a notification as read
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Notification marked as read
 */
router.patch("/:id/read", auth, markAsRead);

/**
 * @swagger
 * /api/notifications/read-all:
 *   patch:
 *     tags: [Notifications]
 *     summary: Mark all notifications as read
 *     responses:
 *       200:
 *         description: All notifications marked as read
 */
router.patch("/read-all", auth, markAllAsRead);

module.exports = router;
