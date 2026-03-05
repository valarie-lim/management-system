<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-teacher-address.aspx.vb" Inherits="sunday_school_ms.manage_teacher_address" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Manage Teacher Address</title>
    <style>
    table {border-collapse: collapse;width: 40%;}
    th, td {font-size:20px;border: 1px solid black;padding: 8px;}
    .myCell {padding: 8px;font-size: 18px;text-align: left;}
    .myHeader {background-color: #FFE9A7;font-weight: bold;padding: 6px;text-align: center;}
    .btn {cursor: pointer; font-size:18px; color: black; text-decoration: none; background-color: palegreen; border: 1px solid none; padding: 5px 10px; border-radius: 5px;}
    .btn:hover{color: whitesmoke; background-color: forestgreen;}
    .btn-del {cursor: pointer; font-size:18px; color: black; text-decoration: none; background-color: lightsalmon; border: 1px solid none; padding: 5px 10px; border-radius: 5px;}
    .btn-del:hover{color: whitesmoke; background-color: maroon ;}
</style>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="menu-container">
            <div class="right-menu-container">
                <h2>更新事奉项目</h2>
                <hr />
                <div class="filter-menu">
                    <asp:DetailsView
                        ID="DetailsView_ManageTeacherAddress"
                        runat="server"
                        CssClass="teacher-details"
                        DataSourceID="SqlDataSource_teacherAddress"
                        AutoGenerateRows="False"
                        DataKeyNames="address_id"
                        CellPadding="8"
                        BackColor="White"
                        BorderColor="White"
                        BorderStyle="Solid"
                        BorderWidth="1px"
                        ForeColor="Black"
                        GridLines="Vertical">

                        <AlternatingRowStyle BackColor="White" />
                        <EditRowStyle BackColor="#e8e8e8" Font-Bold="True" ForeColor="Black" />

                        <Fields>
                            <asp:BoundField DataField="address_id" HeaderText="Address ID" Visible="False" ReadOnly="True">
                                <ItemStyle CssClass="myCell" />
                                <HeaderStyle CssClass="myHeader" />
                            </asp:BoundField>
                            <asp:BoundField DataField="chinese_name" HeaderText="老师名字" ReadOnly="True">
                                <ItemStyle CssClass="myCell" />
                                <HeaderStyle CssClass="myHeader" />
                            </asp:BoundField>
                            <asp:BoundField DataField="street_address" HeaderText="街道地址">
                                <ItemStyle CssClass="myCell" />
                                <HeaderStyle CssClass="myHeader" />
                            </asp:BoundField>
                            <asp:BoundField DataField="city" HeaderText="城市">
                                <ItemStyle CssClass="myCell" />
                                <HeaderStyle CssClass="myHeader" />
                            </asp:BoundField>
                            <asp:BoundField DataField="postcode" HeaderText="邮政编码">
                                <ItemStyle CssClass="myCell" />
                                <HeaderStyle CssClass="myHeader" />
                            </asp:BoundField>
                            <asp:BoundField DataField="state_province" HeaderText="州 / 省">
                                <ItemStyle CssClass="myCell" />
                                <HeaderStyle CssClass="myHeader" />
                            </asp:BoundField>
                            <asp:BoundField DataField="country" HeaderText="国家">
                                <ItemStyle CssClass="myCell" />
                                <HeaderStyle CssClass="myHeader" />
                            </asp:BoundField>

                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton
                                        ID="lnkEdit"
                                        runat="server"
                                        CommandName="Edit"
                                        Text="编辑"
                                        CssClass="btn" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton
                                        ID="lnkUpdate"
                                        runat="server"
                                        CommandName="Update"
                                        Text="更新"
                                        CssClass="btn" />
                                    &nbsp;
                                <asp:LinkButton
                                    ID="lnkCancel"
                                    runat="server"
                                    CommandName="Cancel"
                                    Text="取消"
                                    CssClass="btn-del" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                        </Fields>

                        <FooterStyle BackColor="White" />
                        <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Center" />
                    </asp:DetailsView>

                    <asp:SqlDataSource
                        ID="SqlDataSource_teacherAddress"
                        runat="server"
                        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
                        SelectCommand="
                    SELECT 
                        p.address_id,
                        p.chinese_name,
                        a.street_address,
                        a.city,
                        a.postcode,
                        a.state_province,
                        a.country
                    FROM person p
                    INNER JOIN address a ON p.address_id = a.address_id
                    WHERE p.address_id = @address_id"
                        UpdateCommand="
                    UPDATE address
                    SET 
                        street_address=@street_address,
                        city=@city,
                        postcode=@postcode,
                        state_province=@state_province,
                        country=@country
                    WHERE address_id=@address_id;
                    ">
                        <SelectParameters>
                            <asp:SessionParameter Name="address_id" SessionField="TeacherAddress" Type="String" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="street_address" Type="String" />
                            <asp:Parameter Name="city" Type="String" />
                            <asp:Parameter Name="postcode" Type="String" />
                            <asp:Parameter Name="state_province" Type="String" />
                            <asp:Parameter Name="country" Type="String" />
                            <asp:SessionParameter Name="address_id" SessionField="TeacherAddress" Type="String" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                    <asp:Button ID="BtnDone" runat="server" CssClass="btn-form-style"
                        ClientIDMode="Static"
                        OnClientClick="return confirm('确定要退出编辑吗？');"
                        Text="结束编辑" />
                </div>
            </div>
        </div>
</asp:Content>
