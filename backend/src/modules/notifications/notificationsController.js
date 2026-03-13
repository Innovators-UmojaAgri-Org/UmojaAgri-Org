const notificationsService = require("./notificationsService");

async function listNotifications(req, res) {
  try {
    const notifications = await notificationsService.getNotifications(req.user.userId);
    const unreadCount = await notificationsService.getUnreadCount(req.user.userId);
    res.json({
      success: true,
      unread_count: unreadCount,
      count: notifications.length,
      data: notifications,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function markAsRead(req, res) {
  try {
    await notificationsService.markAsRead(req.params.id, req.user.userId);
    res.json({ success: true, message: "Notification marked as read" });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

async function markAllAsRead(req, res) {
  try {
    await notificationsService.markAllAsRead(req.user.userId);
    res.json({ success: true, message: "All notifications marked as read" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = { listNotifications, markAsRead, markAllAsRead };
