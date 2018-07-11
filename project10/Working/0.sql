INSERT INTO `categories` (`id`, `name`) VALUES (1, 'Features');
INSERT INTO `categories` (`id`, `name`) VALUES (2, 'News');
INSERT INTO `categories` (`id`, `name`) VALUES (3, 'Reviews');
INSERT INTO `categories` (`id`, `name`) VALUES (4, 'Tutorials');

INSERT INTO `posts` (`title`, `strap`, `content`, `category`, `slug`, `date`) VALUES ("iPhone X review", "Don't miss our *exclusive* hands-on", "**The iPhone X promises to be the best ever, but does it live up to that claim?**\n\nYes. The End.", 3, "iphone-x-review", NOW());
INSERT INTO `posts` (`title`, `strap`, `content`, `category`, `slug`, `date`) VALUES ("How to write macOS apps", "It's easier thank you think!", "You should buy [Hacking with macOS](https://www.hackingwithswift.com/store/hacking-with-macos).", 4, "how-to-write-macos-apps", NOW());

