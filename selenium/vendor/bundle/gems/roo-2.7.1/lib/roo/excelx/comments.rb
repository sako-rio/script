require 'roo/excelx/extractor'

module Roo
  class Excelx
    class Comments < Excelx::Extractor
      def comments
        @comments ||= extract_comments
      end

      private

      def extract_comments
        return {} unless doc_exists?

        Hash[doc.xpath('//comments/commentList/comment').map do |comment|
          value = (comment.at_xpath('./text/r/t') || comment.at_xpath('./text/t')).text
          [::Roo::Utils.ref_to_key(comment.attributes['ref'].to_s), value]
        end]
      end
    end
  end
end
# xl/comments1.xml
#   <?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
#   <comments xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
#     <authors>
#       <author />
#     </authors>
#     <commentList>
#       <comment ref="B4" authorId="0">
#         <text>
#           <r>
#             <rPr>
#               <sz val="10" />
#               <rFont val="Arial" />
#               <family val="2" />
#             </rPr>
#             <t>Comment for B4</t>
#           </r>
#         </text>
#       </comment>
#       <comment ref="B5" authorId="0">
#         <text>
#           <r>
#             <rPr>
#             <sz val="10" />
#             <rFont val="Arial" />
#             <family val="2" />
#           </rPr>
#             <t>Comment for B5</t>
#           </r>
#         </text>
#       </comment>
#     </commentList>
#   </comments>
