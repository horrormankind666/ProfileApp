/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๑๗/๑๒/๒๕๕๗>
Modify date : <๐๖/๐๕/๒๕๕๘>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานฟังก์ชั่นการส่งออกข้อมูลเป็นเอกสาร PDF>
=============================================
*/

using System;
using System.IO;
using System.Web;
using iTextSharp.text;
using iTextSharp.text.pdf;
using NUtil;

namespace NExportToPDF
{
    public class ExportToPDF
    {
        private static PdfReader _reader;
        private static Document _document;
        private static PdfWriter _writer;
        private static PdfContentByte _cb;
        private static Image _img;
        private static FileStream _fs;

        public void ExportToPDFConnect(string _fileName)
        {
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.ContentType = Util.GetHeaderContentType("pdf");
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + _fileName);
        }

        public void ExportToPDFConnectWithSaveFile(string _fileName)
        {
            _fs = new FileStream(_fileName, FileMode.Create);
        }

        public void PDFConnectTemplate(string _template, string _type)
        {
            string _pdfTemplate = HttpContext.Current.Server.MapPath(_template);

            if (_type.Equals("pdf") || _type.Equals("pdfwithsavefile"))
            {
                _reader = new PdfReader(_pdfTemplate);
                _document = new Document();

                if (_type.Equals("pdf"))
                    _writer = PdfWriter.GetInstance(_document, HttpContext.Current.Response.OutputStream);

                if (_type.Equals("pdfwithsavefile"))
                    _writer = PdfWriter.GetInstance(_document, _fs);

                _document.Open();
                _cb = _writer.DirectContent;
            }

            /*
            if (_type.Equals("image"))
            {
                _document = new Document(PageSize.A4);
                _writer = PdfWriter.GetInstance(_document, HttpContext.Current.Response.OutputStream);
                _img = Image.GetInstance(_pdfTemplate);
                _img.Alignment = Image.ALIGN_CENTER;
                _img.SetAbsolutePosition(5, 0);
                _img.ScaleToFit(600, 800);

                _document.Open();
                _cb = _writer.DirectContent;
                _cb.AddImage(_img);
            }
            */
        }

        public void PDFAddTemplate(string _type, int _pageNumber, int _rotation)
        {
            if (_type.Equals("pdf"))
            {
                _document.SetPageSize(_rotation.Equals(1) ? PageSize.A4 : PageSize.A4.Rotate());
                PdfImportedPage _page = _writer.GetImportedPage(_reader, _pageNumber);
                PDFNewPage();
                _cb.AddTemplate(_page, 0, 0);
            }
        }

        public void PDFNewPage()
        {
            _document.NewPage();
        }

        public void FillForm(string _font, float _fontSize, int _align, string _text, float _x, float _y, float _width, float _height)
        {
            PdfPTable _table = new PdfPTable(1);
            PdfPCell _cell;
            string _pdfFont = HttpContext.Current.Server.MapPath(_font);

            _table.TotalWidth = _width;
            BaseFont _bf = BaseFont.CreateFont(_pdfFont, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            _cell = new PdfPCell(new Phrase(_text, new Font(_bf, _fontSize, Font.NORMAL, BaseColor.BLACK)));
            _cell.SetLeading(0.0f, 0.7f);
            _cell.Border = 0;
            /*
            _cell.BorderWidthLeft = 1;
            _cell.BorderWidthTop = 1;
            _cell.BorderWidthRight = 1;
            _cell.BorderWidthBottom = 1;
            */
            _cell.HorizontalAlignment = _align;
            _cell.VerticalAlignment = PdfPCell.ALIGN_BOTTOM;
            _cell.NoWrap = false;
            _cell.FixedHeight = _height;
            _cell.MinimumHeight = _height;
            _table.AddCell(_cell);
            _table.WriteSelectedRows(0, -1, _x, _y, _cb);
        }

        public void FillFormCellTop(string _font, float _fontSize, int _align, string _text, float _x, float _y, float _width, float _height)
        {
            PdfPTable _table = new PdfPTable(1);
            PdfPCell _cell;
            string _pdfFont = HttpContext.Current.Server.MapPath(_font);

            _table.TotalWidth = _width;
            BaseFont _bf = BaseFont.CreateFont(_pdfFont, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            _cell = new PdfPCell(new Phrase(_text, new Font(_bf, _fontSize, Font.NORMAL, BaseColor.BLACK)));
            _cell.Border = 0;
            _cell.HorizontalAlignment = _align;
            _cell.VerticalAlignment = PdfPCell.ALIGN_TOP;
            _cell.NoWrap = false;
            _cell.FixedHeight = _height;
            _cell.MinimumHeight = _height;
            _table.AddCell(_cell);
            _table.WriteSelectedRows(0, -1, _x, _y, _cb);
        }

        public void ShowMessage(string _font, float _fontSize, int _align, string _text, float _x, float _y, float _width, float _height, float _lineHeight)
        {
            string _pdfFont = HttpContext.Current.Server.MapPath(_font);
            BaseFont _bf = BaseFont.CreateFont(_pdfFont, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            ColumnText _ct = new ColumnText(_cb);
            Phrase _myText = new Phrase(_text, new Font(_bf, _fontSize, Font.NORMAL, BaseColor.BLACK));
            _ct.SetSimpleColumn(_myText, _x, _y, _width, _height, _lineHeight, _align);
            _ct.Go();
        }

        public void FillFormImage(int _align, string _source, string _imgFile, float _x, float _y, float _width, float _height)
        {
            try
            {
                PdfPTable _table = new PdfPTable(1);
                PdfPCell _cell;

                switch (_source)
                {
                    case "url":
                        _img = Image.GetInstance(new Uri(_imgFile));
                        break;
                    case "file":
                        _img = Image.GetInstance(HttpContext.Current.Server.MapPath(_imgFile));
                        break;
                }

                _table.TotalWidth = _width;
                _img.ScaleToFit(_width, _height);
                _cell = new PdfPCell(_img);
                _cell.Border = 0;
                _cell.HorizontalAlignment = _align;
                _cell.VerticalAlignment = PdfPCell.ALIGN_BOTTOM;
                _cell.NoWrap = false;
                _cell.FixedHeight = _height;
                _cell.MinimumHeight = _height;
                _cell.AddElement(_img);
                _table.AddCell(_cell);
                _table.WriteSelectedRows(0, -1, _x, _y, _cb);
            }
            catch
            {
            }
        }

        public void CreateTable(float _x, float _y, float _width, float _height, float _borderLeft, float _borderTop, float _borderRight, float _borderBottom)
        {
            PdfPTable _table = new PdfPTable(1);
            PdfPCell _cell;

            _table.TotalWidth = _width;
            _cell = new PdfPCell();
            _cell.BorderWidthLeft = _borderLeft;
            _cell.BorderWidthTop = _borderTop;
            _cell.BorderWidthRight = _borderRight;
            _cell.BorderWidthBottom = _borderBottom;
            _cell.NoWrap = false;
            _cell.FixedHeight = _height;
            _cell.MinimumHeight = _height;
            _table.AddCell(_cell);
            _table.WriteSelectedRows(0, -1, _x, _y, _cb);
        }

        public void ExportToPdfDisconnect()
        {
            _reader.Close();
            _document.Close();
            _writer.Close();

            HttpContext.Current.Response.End();
        }

        public void ExportToPdfDisconnectWithSaveFile()
        {
            _reader.Close();
            _document.Close();
            _writer.Close();
        }
    }
}
