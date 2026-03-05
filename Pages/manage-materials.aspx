<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-materials.aspx.vb" Inherits="sunday_school_ms.manage_materials" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Course and Materials Management</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <section>
            <div class="menu-container">

                <div class="side-menu-container" onclick="event.stopPropagation()">
                    <button class="btn-menu" style="margin-top:50px;" type="button" onclick="navigateTo('admin-dashboard.aspx')">主界面</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-children.aspx')">儿童与家长管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-teacher.aspx')">老师管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-activity.aspx')">活动管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-materials.aspx')">材料管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-users.aspx')">系统用户管理</button>
                </div>

                <!-- Main content inside form -->
                <div class="right-menu-container">
                    <h3>材料管理</h3>
                    <hr />
                    <div class="filter-menu">
                        <div class="filter-wrapper">
                            <button type="button" onclick="navigateTo('add-new-material.aspx')">添加新材料</button>
                        </div>
                    <br />
                        <div class="filter-wrapper">
                            <asp:Label ID="lblMaterial" runat="server" Text="选择材料：" AssociatedControlID="ddlSearchMaterial" />
                            <asp:DropDownList ID="ddlSearchMaterial" runat="server" CssClass="filter-txtbox"
                                AutoPostBack="true"
                                DataSourceID="SqlDataSource_materialList"
                                DataTextField="book_title"
                                DataValueField="book_title">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <br />
                    <asp:GridView ID="GridView_material" runat="server"
                        AllowPaging="True" PageSize="20" AllowSorting="True" AutoGenerateColumns="False"
                        BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px"
                        CellPadding="3" ForeColor="Black" GridLines="Vertical"
                        DataKeyNames="material_id" DataSourceID="SqlDataSource_material">
                        <AlternatingRowStyle BackColor="#CCCCCC" />
                        <Columns>
                            <asp:CommandField ShowEditButton="True" SelectText="Edit" ItemStyle-Width="5%">
                                <ItemStyle Width="5%"></ItemStyle>
                            </asp:CommandField>
                            <asp:BoundField DataField="material_id" HeaderText="material_id" Visible="False" ReadOnly="True" />
                            <asp:BoundField DataField="book_title" HeaderText="材料" SortExpression="book_title" />
                            <asp:BoundField DataField="book_chapter" HeaderText="章节" SortExpression="book_chapter" />
                            <asp:BoundField DataField="published_year" HeaderText="出版年份" SortExpression="published_year" />
                            <asp:BoundField DataField="remark" HeaderText="备注" />
                        </Columns>
                        <FooterStyle BackColor="#CCCCCC" />
                        <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#FFE9A7" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="" />
                            <SortedAscendingHeaderStyle BackColor="#CAC9C9" />
                            <SortedDescendingCellStyle BackColor="#F1F1F1" />
                            <SortedDescendingHeaderStyle BackColor="#383838" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource_materialList" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT 'All' AS book_title
                            UNION
                            SELECT DISTINCT book_title 
                            FROM material
                            ORDER BY book_title ASC;"></asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_material" runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                            SELECT material_id,book_title, book_chapter, published_year, remark
                            FROM [material]
                            WHERE (@title = 'all' OR LOWER(book_title) LIKE '%' + LOWER(@title) + '%')
                        ORDER BY book_title ASC"
                        UpdateCommand="
                            UPDATE [material] 
                            SET book_title=@book_title, 
                                book_chapter=@book_chapter, 
                                published_year=@published_year, 
                                remark=@remark
                            WHERE material_id=@material_id">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ddlSearchMaterial"
                                Name="title" PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="book_title" Type="String" />
                            <asp:Parameter Name="book_chapter" Type="String" />
                            <asp:Parameter Name="published_year" Type="String" />
                            <asp:Parameter Name="remark" Type="String" />
                            <asp:Parameter Name="material_id" Type="String" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </section>
</asp:Content>