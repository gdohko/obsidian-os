// Sapphire OS Plasma 6 first-login layout.
var desktopList = desktops();
for (var i = 0; i < desktopList.length; i++) {
    var desktop = desktopList[i];
    desktop.wallpaperPlugin = "org.kde.image";
    desktop.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    desktop.writeConfig("Image", "file:///usr/share/backgrounds/sapphire/desert-dunes.svg");
}
var panelList = panels();
var hasTopPanel = false;
for (var j = 0; j < panelList.length; j++) {
    var currentPanel = panelList[j];
    if (currentPanel.location === "top") hasTopPanel = true;
    else if (currentPanel.location === "bottom") currentPanel.remove();
}
if (!hasTopPanel) {
    var panel = new Panel;
    panel.location = "top";
    panel.height = 38;
    panel.lengthMode = "fill";
    panel.alignment = "left";
    panel.hiding = "dodgewindows";
    panel.addWidget("org.kde.plasma.kickoff");
    panel.addWidget("org.kde.plasma.taskmanager");
    var spacer = panel.addWidget("org.kde.plasma.panelspacer");
    spacer.writeConfig("expanding", "true");
    panel.addWidget("org.kde.plasma.systemtray");
    panel.addWidget("org.kde.plasma.digitalclock");
}
