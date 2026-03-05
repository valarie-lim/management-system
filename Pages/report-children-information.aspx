<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="report-children-information.aspx.vb" Inherits="sunday_school_ms.report_children_information" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Children Information</title>
    <link runat="server" rel="stylesheet" href="../CSS/style.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <header id="main-header">
            <div class="header-left">
                <a href="#" class="logo-style">
                    <img src="../Images/logo.png" /></a>
                <h3>Children Information</h3>
            </div>
            <div class="header-right">
                <ul class="navlist">
                    <li><span id="LiveClock" class="timestamp-font-size"></span></li>
                </ul>
                <asp:Button ID="BtnReturn" runat="server" CssClass="btn-normal" Style="border-radius: 5px;" Text="Return" />
            </div>
        </header>
        <br />

        <div class="menu-container">
            <div class="right-menu-container">
                <div class="filter-menu">
                    <div class="filter-wrapper">
                        <asp:Label ID="lblActive" runat="server" Text="Status:" AssociatedControlID="ddlSearchActive" />
                        <asp:DropDownList ID="ddlSearchActive" runat="server" CssClass="filter-txtbox"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlSearchActive_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:Button ID="BtnExportPDF" runat="server" Text="Save as PDF" CssClass="btn-filter" OnClick="BtnExportPDF_Click" />
                    </div>
                </div>
                <br />

                <!-- GridView -->
                <asp:GridView ID="GridView_Child" runat="server" CssClass="my-grid"
                    AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                    CellPadding="3" DataSourceID="SqlDataSource_childInfo"
                    ForeColor="Black" GridLines="Vertical" Width="100%"
                    DataKeyNames="child_id">

                    <AlternatingRowStyle BackColor="#CCCCCC" />

                    <Columns>
                        <asp:BoundField DataField="age" HeaderText="Age" ReadOnly="True" />
                        <asp:BoundField DataField="class_name" HeaderText="Class" ReadOnly="True" />
                        <asp:BoundField DataField="chinese_name" HeaderText="中文" ReadOnly="True" />
                        <asp:BoundField DataField="FullName" HeaderText="Name" ReadOnly="True" />
                        <asp:BoundField DataField="gender" HeaderText="Gender" ReadOnly="True" />
                        <asp:BoundField DataField="dob" HeaderText="Date of Birth" DataFormatString="{0:dd-MM-yyyy}" ReadOnly="True" />
                        <asp:BoundField DataField="FullAddress" HeaderText="Address" ReadOnly="True" />
                        <asp:BoundField DataField="religion" HeaderText="Religion" ReadOnly="True" />
                        <asp:BoundField DataField="Guardians" HeaderText="Guardian" ReadOnly="True" />
                    </Columns>
                    <FooterStyle BackColor="#CCCCCC" />
                    <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#F1F1F1" />
                    <SortedAscendingHeaderStyle BackColor="#808080" />
                    <SortedDescendingCellStyle BackColor="#CAC9C9" />
                    <SortedDescendingHeaderStyle BackColor="#383838" />
                </asp:GridView>


                <!-- Data Source Child and Class -->
                <asp:SqlDataSource ID="SqlDataSource_childInfo" runat="server"
                    ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                    SelectCommand="
                        SELECT
                            c.child_id,
                            c.age,
                            cl.class_name,
                            c.chinese_name,
                            (c.first_name + ' ' + c.last_name) AS FullName,
                            c.gender,
                            c.dob,
                            (a.street_address + ' ' + a.city + ' ' + a.postcode + ' ' + a.state_province + ' ' + a.country) AS FullAddress,
                            c.religion,
                            STRING_AGG(re.relation_type + ': ' + p.first_name + ' ' + p.last_name + ' (' + p.contact_no + ')', ', ') 
		                        WITHIN GROUP (ORDER BY re.relation_type, p.first_name, p.last_name) AS Guardians,
                            c.isArchive
                        FROM child c
                            LEFT JOIN class cl ON c.class_id=cl.class_id
                            LEFT JOIN relationship re ON c.child_id = re.child_id
                            LEFT JOIN guardian g ON re.guardian_id = g.guardian_id
                            LEFT JOIN person p ON g.person_id = p.person_id
                            LEFT JOIN address a ON p.address_id = a.address_id
                        WHERE 
                            (
                                (@isArchive = '0' AND c.isArchive = 0) OR
                                (@isArchive = '1' AND c.isArchive = 1) OR
                                (@isArchive = '2' AND YEAR(c.joined_date) = YEAR(GETDATE()))
                            )
                        GROUP BY 
                            c.child_id,
                            c.age,
                            cl.class_name,
                            c.chinese_name,
                            (c.first_name + ' ' + c.last_name),
                            c.gender,
                            c.dob,
                            (a.street_address + ' ' + a.city + ' ' + a.postcode + ' ' + a.state_province + ' ' + a.country),
                            c.religion,
                            c.isArchive
                        ORDER BY c.age;
                    ">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ddlSearchActive" Name="isArchive" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>

            </div>
        </div>
    </form>
</body>
</html>
