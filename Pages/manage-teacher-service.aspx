<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-teacher-service.aspx.vb" Inherits="sunday_school_ms.manage_teacher_service" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Manage Teacher Service</title>
    <style>
        table { border-collapse: collapse; width: 70%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background-color: #ffe9a7; }
        .btn {cursor: pointer; font-size:18px; color: black; text-decoration: none; background-color: palegreen; border: 1px solid none; padding: 5px 10px; border-radius: 5px;}
        .btn:hover{color: whitesmoke; background-color: forestgreen;}
        .btn-del {cursor: pointer; font-size:18px; color: black; text-decoration: none; background-color: lightsalmon; border: 1px solid none; padding: 5px 10px; border-radius: 5px;}
        .btn-del:hover{color: whitesmoke; background-color: maroon;}
    </style>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <!-- main content -->
        <div class="menu-container">
            <div class="right-menu-container">
                <h2>更新事奉项目</h2>
                <hr />
                <div class="filter-menu">
                    <asp:GridView ID="gvTeacherServices" runat="server"
                        AutoGenerateColumns="False" ShowFooter="True"
                        OnRowEditing="gvTeacherServices_RowEditing"
                        OnRowUpdating="gvTeacherServices_RowUpdating"
                        OnRowCancelingEdit="gvTeacherServices_RowCancelingEdit"
                        OnRowDeleting="gvTeacherServices_RowDeleting"
                        OnRowCommand="gvTeacherServices_RowCommand"
                        OnRowDataBound="gvTeacherServices_RowDataBound"
                        DataKeyNames="serviceList_id">

                        <Columns>
                            <asp:BoundField DataField="chinese_name" HeaderText="老师名字" ReadOnly="True" />

                            <asp:TemplateField HeaderText="事奉项目">
                                <ItemTemplate>
                                    <%# Eval("service_type") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditService" runat="server" AppendDataBoundItems="True">
                                        <asp:ListItem Text="- 选择事奉项目 -" Value="" />
                                    </asp:DropDownList>
                                </EditItemTemplate>

                                <FooterTemplate>
                                    <asp:DropDownList ID="ddlNewService" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlNewService_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    &nbsp;
                                <asp:TextBox ID="txtNewService" runat="server" Visible="False" Placeholder="输入事奉项目" />
                                    &nbsp;
                                <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" Width="150px" />
                                    &nbsp;
                                <asp:LinkButton ID="lnkAdd" runat="server" CommandName="AddNew" Text="添加新事奉项目" CssClass="btn" />

                                </FooterTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="开始日期">
                                <ItemTemplate>
                                    <%# Eval("start_date", "{0:yyyy-MM-dd}") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtCurrentStartDate" runat="server" Text='<%# Bind("start_date", "{0:yyyy-MM-dd}") %>' TextMode="Date" Width="150px" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" Text="编辑" CssClass="btn" />
                                    &nbsp;|&nbsp;
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" Text="删除" CssClass="btn-del"
                                    OnClientClick="return confirm('确定要删除此事奉吗？');" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" Text="更新" CssClass="btn" />
                                    &nbsp;|&nbsp;
                                <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel" Text="取消" CssClass="btn-del" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <br />
                    <asp:Button ID="BtnDone" runat="server" CssClass="btn-form-style"
                        ClientIDMode="Static"
                        Text="结束编辑" />
                </div>
            </div>
        </div>
</asp:Content>
