rm(list = ls())
library(DiagrammeR)

m <- mermaid("
      gantt
      dateFormat  YYYY-MM-DD
      title Project timeline
      
      section Data analysis
      care for broccoli                      :        data_1,    2018-12-10, 40d
      Broccoli treatment / collect data      :        data_2,    2018-12-31, 15d
      Algorithm learning                     :        data_3,    2018-12-10, 40d
      Analyze conveyor belt data            :        data_4,    2018-12-21, 15d
      Analyze stress data                   :        data_5,    after data_2, 40d
      Matabolomics analysis                  :        data_6,    after data_5, 40d
      Collect filed data                     :        data_7,    after data_6, 40d
      Analysis filed data                    :        data_8,    after data_7, 40d

      section Research
      Initial reading                    :    res_1,   2018-12-10, 21d?pn
      Methods for belt data              :    res_2,   after data_4, 3d
      Methods for stress data            :    res_3,   after data_5, 7d
      Methods for matabolomics data      :    res_4,   after data_6, 7d
      Methods for filed data             :    res_5,   after data_7, 7d
      Write introduction                 :    res_6,   after res_1, 30d
      Write results                      :    res_7,   after data_8, 21d
      Write discussion                   :    res_8,   after res_7, 30d
")

# mermaid does not return an image. It returns html instructions on how to draw an image. 
print(m)
