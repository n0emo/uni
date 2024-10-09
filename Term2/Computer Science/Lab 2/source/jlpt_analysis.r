jlpt_csv <- read.csv("JLPT.csv")
years <- subset(jlpt_csv, jlpt_csv$Level == "N1")$Year
applications <- as.integer(gsub(",", "", (c(subset(jlpt_csv, jlpt_csv$Level == "N1")$Applicants)))) # nolint
xx <- 1:23
line <- lm(applications ~ xx)
plot(applications, xlab = "Years",
    main = "Applications of JLPT N1 in Japan")
abline(line, col = "red")
axis(1, at = seq_along(applications), labels = years, las = 2)
print(summary(applications))
