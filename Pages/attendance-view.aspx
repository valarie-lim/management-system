<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="attendance-view.aspx.vb" Inherits="sunday_school_ms.attendance_view" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Manage Child Attendance</title>
    <style>
    table {border-collapse: collapse;width: 50%;}
    th, td {border: 1px solid #ccc;padding: 8px;}
</style>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <h4>出勤管理</h4>
                    <asp:Button ID="BtnReturn" runat="server" CssClass="btn-normal" Style="border-radius: 5px;"
                        Text="回去出勤登记" />
                </div>
            </div>
            <hr />
            <div class="filter-menu">
                <div class="filter-wrapper">
                    <!-- YEAR -->
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="filter-txtbox"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlYear_SelectedIndexChanged">
                    </asp:DropDownList>

                    <!-- MONTH -->
                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="filter-txtbox"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged">
                    </asp:DropDownList>

                    <!-- ACTIVITY -->
                    <asp:DropDownList ID="ddlActivity" runat="server" CssClass="filter-txtbox"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlActivity_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:Button ID="BtnViewReport" runat="server" Text="查看出勤汇总 (Attendance Summaries)" CssClass="btn-filter" />
                </div>

            </div>
            <br />
            <asp:GridView ID="GridView_childAttendance" runat="server"
                AllowPaging="True" PageSize="60" AllowSorting="True" AutoGenerateColumns="False" AutoGenerateEditButton="False"
                BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                CellPadding="3" DataSourceID="SqlDataSource_childAttendance"
                ForeColor="Black" GridLines="Vertical" Width="100%"
                DataKeyNames="child_id,attendance_id" ControlStyle-Height="20px">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:BoundField DataField="attendance_id" HeaderText="Attendance ID" ReadOnly="True" Visible="False" />
                    <asp:BoundField DataField="EnglishName" HeaderText="名字（英）" ItemStyle-Width="200px"
                        SortExpression="EnglishName" ReadOnly="True" ControlStyle-Width="100px">
                        <ControlStyle Width="100px"></ControlStyle>

                        <ItemStyle Width="160px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="chinese_name" HeaderText="名字（中）" ReadOnly="True">
                        <ItemStyle Width="60px"></ItemStyle>
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="性别" HeaderStyle-Width="50" SortExpression="gender">
                        <ItemTemplate>
                            <%# If(Eval("gender").ToString()="1","男","女") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="age" HeaderText="年龄" SortExpression="age" ReadOnly="True">
                        <ItemStyle Width="50px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="Guardians" HeaderText="家长" ReadOnly="True">
                        <ItemStyle Width="180px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="class_name" HeaderText="班级" ReadOnly="True">
                        <ItemStyle Width="100px"></ItemStyle>
                    </asp:BoundField>
                    <asp:CheckBoxField DataField="isPresent" HeaderText="出席"
                        ItemStyle-Width="50px" ControlStyle-Height="50px" ControlStyle-Width="50px" ItemStyle-Wrap="False" />
                    <asp:CommandField ShowEditButton="True" ItemStyle-Width="50px" SelectText="Edit">
                        <ItemStyle Width="50px"></ItemStyle>
                    </asp:CommandField>
                </Columns>
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#FFE9A7" Font-Bold="True" ForeColor="White" CssClass="selectedRow" />
                <SortedAscendingCellStyle BackColor="" />
                <SortedAscendingHeaderStyle BackColor="#CAC9C9" />
                <SortedDescendingCellStyle BackColor="#F1F1F1" />
                <SortedDescendingHeaderStyle BackColor="#383838" />
            </asp:GridView>

            <asp:SqlDataSource ID="SqlDataSource_childAttendance" runat="server"
                ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                SelectCommand="
                        SELECT 
                            c.child_id,
                            a.activity_name,
                            s.activity_date,
                            att.attendance_id,
                            (c.first_name + ' ' + c.last_name) AS EnglishName,
                            c.chinese_name,
                            c.gender,
                            c.age,
                            cl.class_name,
                            STRING_AGG(p.first_name + ' ' + p.last_name + ' (' + p.contact_no + ')', ', ') 
                                WITHIN GROUP (ORDER BY re.guardian_id) AS Guardians,
                            ca.isPresent
                        FROM child c
                        LEFT JOIN class cl ON c.class_id = cl.class_id
                        INNER JOIN childAttendance ca ON c.child_id = ca.child_id
                        INNER JOIN attendance att ON ca.attendance_id = att.attendance_id
                        INNER JOIN activitySchedule s ON att.schedule_id = s.schedule_id
                        INNER JOIN activity a ON s.activity_id = a.activity_id
                        LEFT JOIN relationship re ON c.child_id = re.child_id
                        LEFT JOIN guardian g ON re.guardian_id = g.guardian_id
                        LEFT JOIN person p ON g.person_id = p.person_id
                        WHERE (@schedule_id IS NOT NULL AND s.schedule_id = @schedule_id)
                        GROUP BY 
                            c.child_id, a.activity_name, s.activity_date, att.attendance_id,
                            c.first_name, c.last_name, c.chinese_name, c.gender, c.age, cl.class_name, ca.isPresent
                        ORDER BY s.activity_date DESC, a.activity_name;
                        "
                UpdateCommand="
                        UPDATE childAttendance
                        SET isPresent = @isPresent
                        WHERE child_id = @child_id
                          AND attendance_id = @attendance_id">

                <SelectParameters>
                    <asp:ControlParameter Name="schedule_id" ControlID="ddlActivity" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="isPresent" Type="Boolean" />
                    <asp:Parameter Name="child_id" Type="String" />
                    <asp:Parameter Name="attendance_id" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <br />
        </div>
    </div>
</asp:Content>