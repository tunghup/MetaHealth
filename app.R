# app.r - Đảm bảo đúng thứ tự loading như local

# Load thư viện từ global.r
library(shiny)
library(shinydashboard)
library(meta)
library(netmeta)
library(rhandsontable)

# Load các module theo đúng thứ tự 
source("metahealth_part1.r")
source("metahealth_part2.r")
source("metahealth_part3.r")  
source("metahealth_part4.r")
source("metahealth_part5.r")

# Sau khi tất cả các module đã load, mới load UI và server
source("ui.r")
source("server.r")

# Khởi chạy ứng dụng
shinyApp(ui, server)
